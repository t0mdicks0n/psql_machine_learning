
#### How to run
1. Build the image
```bash
docker build -t psql .
```
2. In another terminal window, ssh into the container
```bash
docker exec -it <container_id> /bin/bash
```
3. Start a postgres shell
```bash
su - postgres
```
4. Start a postgres client
```bash
psql
```
5. Import PL/Python to PSQL
```sql
CREATE LANGUAGE plpython3u;
```
6. Make sure it was able to install
```sql
SELECT * FROM pg_language;
```
7. Try to write something with PL/Python
```sql
CREATE OR REPLACE FUNCTION hello_world ()
RETURNS TEXT
AS $$
return "Can you belive it, this is from Python"
$$ LANGUAGE plpython3u;
```
