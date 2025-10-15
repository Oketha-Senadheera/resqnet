# Database Connection Setup - URGENT FIX

## Problem

You encountered a `NullPointerException` when trying to login because the database connection configuration was missing.

```
java.lang.NullPointerException at DBConnection.getConnection(DBConnection.java:31)
```

## Root Cause

The application requires database connection properties (DB_HOST, DB_USER, DB_PASS, etc.) but they were not configured.

## Solution - Choose ONE Option

### Option 1: Configure application.properties (Recommended for Local Development)

1. **Edit the file:** `src/main/resources/application.properties`

2. **Update with your actual database credentials:**

```properties
DB_HOST=localhost
DB_PORT=3306
DB_NAME=resqnet
DB_SSL_MODE=DISABLED
DB_USER=your_actual_username
DB_PASS=your_actual_password
```

3. **Rebuild and redeploy:**
```bash
mvn clean package
# Then run deploy-tomcat.bat
```

### Option 2: Set Environment Variables (Recommended for Production)

Set these as system environment variables:

**Windows (PowerShell):**
```powershell
$env:DB_HOST="localhost"
$env:DB_PORT="3306"
$env:DB_NAME="resqnet"
$env:DB_SSL_MODE="DISABLED"
$env:DB_USER="your_username"
$env:DB_PASS="your_password"
```

**Windows (Command Prompt):**
```cmd
set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=resqnet
set DB_SSL_MODE=DISABLED
set DB_USER=your_username
set DB_PASS=your_password
```

**Linux/Mac:**
```bash
export DB_HOST=localhost
export DB_PORT=3306
export DB_NAME=resqnet
export DB_SSL_MODE=DISABLED
export DB_USER=your_username
export DB_PASS=your_password
```

Then restart Tomcat.

### Option 3: Configure in Tomcat's context.xml

Add to `$CATALINA_HOME/conf/context.xml` or your app's `META-INF/context.xml`:

```xml
<Context>
    <Environment name="DB_HOST" value="localhost" type="java.lang.String" override="false"/>
    <Environment name="DB_PORT" value="3306" type="java.lang.String" override="false"/>
    <Environment name="DB_NAME" value="resqnet" type="java.lang.String" override="false"/>
    <Environment name="DB_SSL_MODE" value="DISABLED" type="java.lang.String" override="false"/>
    <Environment name="DB_USER" value="your_username" type="java.lang.String" override="false"/>
    <Environment name="DB_PASS" value="your_password" type="java.lang.String" override="false"/>
</Context>
```

## What Was Fixed

1. ✅ **Added null checks** in `DBConnection.java` with helpful error messages
2. ✅ **Created** `application.properties` with default values
3. ✅ **Created** `.env.example` as a template
4. ✅ **Improved error handling** to show which property is missing

## Testing

After configuring the database:

1. Start/Restart Tomcat
2. Navigate to: http://localhost:8080/resqnet/login
3. Try to login with your credentials
4. Should now connect to database successfully

## Database Setup (If Not Done Yet)

Make sure you have:

1. **MySQL installed and running**
2. **Database created:**
   ```sql
   CREATE DATABASE resqnet;
   ```

3. **Tables created:**
   - Run the schema from `src/main/resources/db/migration/resqnet_schema.sql`

4. **Test user created** (for testing login):
   ```sql
   -- Example: Create a test user
   INSERT INTO users (username, email, password_hash, role) 
   VALUES ('testuser', 'test@example.com', '$2a$10$...', 'GENERAL');
   ```

## Security Notes

⚠️ **IMPORTANT:**
- Never commit `application.properties` with real credentials to Git
- Add to `.gitignore`:
  ```
  src/main/resources/application.properties
  .env
  ```
- Use environment variables in production
- The current `application.properties` has placeholder values - UPDATE THEM!

## Next Steps

1. Configure database connection using one of the options above
2. Rebuild the project: `mvn clean package`
3. Redeploy using `deploy-tomcat.bat`
4. Test login functionality
