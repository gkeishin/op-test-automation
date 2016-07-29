# op-test-automation
Place holder for open power robot test automation

# Execution all test suites
python -m robot -v  OPENPOWER_HOST:hostname  -v OPENPOWER_USERNAME:username -v OPENPOWER_PASSWORD:password  -v OPENPOWER_LPAR:lpar_host    tests

# CI Test execution
python -m robot -v  OPENPOWER_HOST:hostname  -v OPENPOWER_USERNAME:username -v OPENPOWER_PASSWORD:password  -v OPENPOWER_LPAR:lpar_host    tests/test_ci.robot

# Code update test case
python -m robot -v  OPENPOWER_HOST:hostname  -v OPENPOWER_USERNAME:username -v OPENPOWER_PASSWORD:password  -v HPM_IMG_PATH:abs_path    tests/test_code_update.robot
