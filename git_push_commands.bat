@echo off
REM ==========================================
REM GIT PUSH COMMANDS - SAFE TO RUN
REM ==========================================

echo.
echo ========================================
echo STEP 1: ADD ALL FILES
echo ========================================
git add .

echo.
echo ========================================
echo STEP 2: COMMIT
echo ========================================
git commit -m "feat: Add contact form & update security docs" -m "- Implement real contact form with Supabase" -m "- Add admin message management" -m "- Add performance optimizations" -m "- Add SEO tools (sitemap & RSS)" -m "- Update README (remove sensitive info)" -m "- Add SECURITY.md policy" -m "- Remove credentials from Git tracking" -m "- Add example configuration files"

echo.
echo ========================================
echo STEP 3: PUSH TO GITHUB
echo ========================================
git push origin main

echo.
echo ========================================
echo DONE! Check GitHub repository
echo ========================================
pause
