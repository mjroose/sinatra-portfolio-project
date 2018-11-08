require './config/environment'

use Rack::MethodOverride

use UsersController
use RecipesController
use ShoppingListsController
run ApplicationController