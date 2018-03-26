module DummyCC::AST
end

# statements
require 'dummycc/ast/base'
require 'dummycc/ast/variable_decl'
require 'dummycc/ast/binary_expr'
require 'dummycc/ast/jump_stmt'
require 'dummycc/ast/call_expr'
require 'dummycc/ast/variable'
require 'dummycc/ast/number'
require 'dummycc/ast/null_expr'

# functions
require 'dummycc/ast/function_stmt'
require 'dummycc/ast/prototype'
require 'dummycc/ast/function'
require 'dummycc/ast/translation_unit'
require 'dummycc/ast/function_signature'
