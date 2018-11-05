require './config/environment'

use Rack::MethodOverride

use UsersController
use RecipesController
run ApplicationController