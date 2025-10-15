# Quick Start Guide - ResQnet Sign-Up System

## Prerequisites
1. MySQL database with schema from `src/main/resources/db/migration/resqnet_schema.sql` applied
2. Environment variables set for database connection:
   - `DB_HOST` - Database host
   - `DB_PORT` - Database port  
   - `DB_NAME` - Database name
   - `DB_USER` - Database username
   - `DB_PASS` - Database password
   - `DB_SSL_MODE` - SSL mode for connection

## Quick Build & Deploy

```bash
# Build WAR file
mvn clean package -DskipTests

# Deploy to Tomcat
cp target/resqnet.war /path/to/tomcat/webapps/

# Or use the provided scripts
./redeploy.sh  # Linux/Mac
deploy-tomcat.bat  # Windows
```

## Testing the Sign-Up System

### 1. Access the Application
- Open browser and navigate to: `http://localhost:8080/resqnet`
- You will be redirected to the role selection page

### 2. Test General User Sign-Up
1. Click "Sign Up" on the General User card
2. Fill in the form:
   - **Personal Information**: Name, Contact Number, Username, Email, Password
   - **Address**: House No, Street, City, District, GN Division
   - Optional: Enable SMS Alerts checkbox
3. Click "Sign Up"
4. Verify you're redirected to login with `?registered=1` parameter

### 3. Test Volunteer Sign-Up
1. Go back to role selection (`/signup`)
2. Click "Sign Up" on the Volunteer card
3. Fill in the form:
   - **Personal Information**: Name, Age, Gender, Contact Number, Username, Email, Password
   - **Address**: House No, Street, City, District, GN Division
   - **Preferences**: Select one or more volunteer preferences
   - **Skills**: Select one or more specialized skills
4. Click "Register"
5. Verify registration success

### 4. Test NGO Sign-Up
1. Go back to role selection
2. Click "Sign Up" on the NGO card
3. Fill in the form:
   - **Organization**: Name, Registration Number, Years of Operation, Address
   - **Contact Person**: Name, Email, Telephone
   - **Account**: Username, Email, Password
4. Click "Sign Up"
5. Verify registration success

### 5. Test Login
1. Go to `/login`
2. Enter credentials from any account created above
3. Verify redirect to appropriate dashboard:
   - General User → `/user/dashboard`
   - Volunteer → `/volunteer/dashboard`
   - NGO → `/ngo/dashboard`

## Database Verification

After sign-up, verify data in database:

```sql
-- Check user account created
SELECT * FROM users WHERE email = 'test@example.com';

-- Check general user profile
SELECT * FROM general_user WHERE user_id = ?;

-- Check volunteer profile
SELECT * FROM volunteers WHERE user_id = ?;

-- Check volunteer skills
SELECT v.name, s.skill_name 
FROM volunteers v
JOIN skills_volunteers sv ON v.user_id = sv.user_id
JOIN skills s ON sv.skill_id = s.skill_id
WHERE v.user_id = ?;

-- Check volunteer preferences
SELECT v.name, vp.preference_name
FROM volunteers v
JOIN volunteer_preference_volunteers vpv ON v.user_id = vpv.user_id
JOIN volunteer_preferences vp ON vpv.preference_id = vp.preference_id
WHERE v.user_id = ?;

-- Check NGO profile
SELECT * FROM ngos WHERE user_id = ?;
```

## Common Issues & Solutions

### Issue: "Error creating user"
**Solution**: Check database connection settings in environment variables

### Issue: "Duplicate entry for username"
**Solution**: Username must be unique, choose a different username

### Issue: "Duplicate entry for email"
**Solution**: Email must be unique, use a different email address

### Issue: CSS not loading
**Solution**: 
1. Check static resources are in `src/main/webapp/static/`
2. Verify `/static/**` path is in AuthFilter's public paths
3. Clear browser cache

### Issue: "Cannot find symbol" compilation error
**Solution**: Run `mvn clean compile` to rebuild from scratch

### Issue: Password reset not working
**Solution**: Ensure email configuration is set up (check MailUtil.java)

## Development Tips

### Adding a New User Role
1. Add role to `Role.java` enum
2. Update `User.java` with helper method (e.g., `isNewRole()`)
3. Create model class for role-specific data
4. Create DAO for the model
5. Create signup servlet
6. Create signup JSP page
7. Update `LoginServlet` redirect logic
8. Update `AuthFilter` role rules
9. Update role selection page

### Modifying Sign-Up Forms
- JSP files are in `src/main/webapp/WEB-INF/views/auth/`
- Update corresponding servlet if adding/removing fields
- Update model class if changing data structure
- Update DAO SQL if changing database fields

### Styling Changes
- Main styles are in `src/main/webapp/static/core.css`
- Use CSS custom properties (variables) for consistency
- Page-specific styles can be inline in JSP files

## API Endpoints Summary

| Method | Path | Description | Auth Required |
|--------|------|-------------|---------------|
| GET | `/` | Redirect to signup | No |
| GET | `/signup` | Role selection | No |
| GET | `/signup/general` | General user form | No |
| POST | `/signup/general` | Create general user | No |
| GET | `/signup/volunteer` | Volunteer form | No |
| POST | `/signup/volunteer` | Create volunteer | No |
| GET | `/signup/ngo` | NGO form | No |
| POST | `/signup/ngo` | Create NGO | No |
| GET | `/login` | Login form | No |
| POST | `/login` | Authenticate user | No |
| GET | `/logout` | Logout user | Yes |
| GET | `/user/**` | General user pages | Yes (GENERAL) |
| GET | `/volunteer/**` | Volunteer pages | Yes (VOLUNTEER) |
| GET | `/ngo/**` | NGO pages | Yes (NGO) |
| GET | `/gn/**` | GN pages | Yes (GRAMA_NILADHARI) |
| GET | `/dmc/**` | DMC pages | Yes (DMC) |

## Next Development Steps

1. **Create Dashboard Pages**: Implement actual dashboard pages for each role
2. **Profile Management**: Add ability to edit profile information
3. **Email Verification**: Implement email verification during signup
4. **Password Strength**: Add password strength indicator
5. **Form Validation**: Enhance client-side validation
6. **Error Handling**: Improve error messages and user feedback
7. **Accessibility**: Add ARIA labels and keyboard navigation
8. **Mobile Optimization**: Ensure forms work well on mobile devices
9. **Testing**: Add unit tests and integration tests
10. **Logging**: Add comprehensive logging for debugging

## Support

For issues or questions:
1. Check MIGRATION_COMPLETE.md for detailed documentation
2. Review database schema in `src/main/resources/db/migration/resqnet_schema.sql`
3. Check servlet error logs in Tomcat
4. Verify database connection in `src/main/java/com/resqnet/util/DBConnection.java`
