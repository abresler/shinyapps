library('testthat')

source('mortgage.R')
source('fnctns.R')
# All test scripts within folders tests must have a filename
# starting with test

#test_dir('tests', reporter = 'Summary')
test_dir('tests', reporter = 'Minimal')
#test_file('tests/test_fnctns.R')
#test_file('tests/test_mortgage.R' , reporter = 'Minimal')

# to do 
# check that monthly cash > rent 
