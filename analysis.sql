--1) Define model return type record,
drop type if exists host_mdl_coef_intercept CASCADE;
create type host_mdl_coef_intercept AS (
	hostname text, -- hostname on which the model was built
	coef float[], -- model coefficients
	intercept float, -- intercepts
	r_square float -- training data fit
);

--2) Define a UDA (user defined aggregate) to concatenate arrays,
drop aggregate if exists array_agg_array(anyarray) CASCADE;
create aggregate array_agg_array(anyarray) (
	SFUNC = array_cat,
	STYPE = anyarray
);

--3) Define PL/Python function to train ridge regression model,
create or replace function sklearn_ridge_regression(
	features_mat float8[],
	n_features int,
	labels float8[]
)
returns host_mdl_coef_intercept
as 
$$
	import os
	from sklearn import linear_model, preprocessing
	import numpy as np
	X_unscaled = np.array(features_mat).reshape(int(len(features_mat)/n_features), int(n_features))
	# Scale the input (zero mean, unit variance)
	X = preprocessing.scale(X_unscaled)
	y = np.array(labels).transpose()
	mdl = linear_model.Ridge(alpha = .5)
	mdl.fit(X, y)
	result = [
		os.popen('hostname').read().strip(),
		mdl.coef_,
		mdl.intercept_,
		mdl.score(X, y)
	]
	return result
$$language plpython3u;
-- Try to run the function
select (
	sklearn_ridge_regression(
		features_mat,
		n_features,
		labels)
		).*
from (
	select
		-- Convert rows of features into a large linear array
		array_agg_array(features order by id) as features_mat,
		-- Number of features
		max(array_upper(features, 1)) as n_features,
		-- Gather all the Labels
		array_agg(quality order by id) as labels
	from (
		select
			id,
			1 as grouping,
			-- Create a feature vector of independent variables,
			ARRAY[
				fixed_acidity,
				volatile_acidity,
				citric_acid,
				residual_sugar,
				chlorides,
				free_sulfur_dioxide,
				total_sulfur_dioxide,
				density,
				ph,
				sulphates,
				alcohol
			] as features,
			quality
		from
			wine_sample
	)q1
	group by
		grouping
)q2;