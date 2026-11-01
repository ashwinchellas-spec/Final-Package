function [db,file] = new_test_database()
%NEW_TEST_DATABASE Reproduce schema/seed in a temporary file, never the production DB.
% Output: DB handle and path. Caller closes handle before deleting the file.
file=[tempname,'.db']; db_initialize(file); db_seed(file); db=DB_Interface(file);
end
