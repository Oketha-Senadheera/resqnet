# Authentication Pages Refactored to Use Core CSS

## Summary

All authentication pages have been updated to use the CSS classes from `core.css` instead of the previous `auth.css` specific classes. This ensures consistency across all pages.

## Updated Files

### 1. Login Page (`login.jsp`)
- Replaced `auth:field` and `auth:button` tags with standard HTML input and button elements
- Uses `.form-field`, `.input`, `.btn`, and `.btn-primary` classes from core.css
- Clean, centered layout with responsive design

### 2. Forgot Password Page (`forgot-password.jsp`)
- Updated to use core CSS classes
- Consistent styling with login page
- Includes legal footer links

### 3. Reset Password Page (`reset-password.jsp`)
- Two password fields (new password + confirm)
- Uses same core CSS classes
- Consistent design language

### 4. Password Reset Requested Page (`forgot-password-requested.jsp`)
- Success state with check icon
- Uses Lucide icons
- Styled with core CSS variables

## CSS Classes Used

All pages now consistently use:

### Layout & Container
- `.auth-container` - Main container (max-width: 440px, centered)
- `.auth-heading` - Page title
- `.auth-subheading` - Subtitle/description text

### Form Elements (from core.css)
- `.form-field` - Form field wrapper
- `.input` - Text input, email input, password input
- `.btn` - Base button styles
- `.btn-primary` - Primary button (yellow accent)
- `.btn-block` - Full-width button

### Feedback & Navigation
- `.error-message` - Error message display
- `.auth-switch` - Switch between auth pages (e.g., "Don't have an account?")
- `.auth-meta` - Additional metadata (e.g., "Forgot Password?" link)
- `.auth-legal` - Legal footer links

## Benefits

✅ **Consistent Design** - All auth pages use the same design system
✅ **Single Source of Truth** - All styles come from `core.css`
✅ **Easier Maintenance** - Changes to form styles affect all pages uniformly
✅ **No Redundancy** - Removed dependency on `auth.css` and custom auth tags
✅ **Responsive** - All layouts work on mobile and desktop
✅ **Clean HTML** - Direct use of standard form elements

## Design Tokens Used

All pages leverage the CSS custom properties from `core.css`:

- `--color-text`, `--color-text-subtle` - Text colors
- `--color-accent`, `--color-accent-hover` - Primary action colors
- `--color-danger` - Error messages
- `--color-border` - Input borders
- `--font-size-sm`, `--font-size-xs` - Typography scale
- `--space-*` - Consistent spacing
- `--radius-sm`, `--radius-pill` - Border radius
- `--shadow-focus` - Focus states

## Testing

Test all authentication flows:
1. Login - http://localhost:8080/resqnet/login
2. Forgot Password - http://localhost:8080/resqnet/forgot-password
3. Reset Password - http://localhost:8080/resqnet/reset-password?token=xxx
4. All pages should have consistent styling with the signup pages
5. Form validation should work properly
6. Responsive design should work on mobile devices

## What Was Removed

- ❌ `auth:field` custom tag usage
- ❌ `auth:button` custom tag usage
- ❌ `auth:link` custom tag usage
- ❌ Dependency on `auth.css` BEM-style classes (`.c-auth__*`)
- ❌ Complex nested component structures

## What Was Kept

- ✅ Same functionality and validation
- ✅ All form attributes (autocomplete, required, minlength, etc.)
- ✅ Error handling
- ✅ Responsive design
- ✅ Accessibility features (labels, aria attributes)
