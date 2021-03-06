require 'httparty'

class RecipeSearchWrapper
  URL = "https://api.edamam.com/"
  APP_ID = ENV["APP_ID"]
  APP_KEY = ENV["APP_KEY"]

  @recipe_list = []

  def self.list_recipes(search)
    encoded_uri = URI.encode("#{URL}search?q=#{search}&app_id=#{APP_ID}&app_key=#{APP_KEY}&from=0&to=30")

    response = HTTParty.get(encoded_uri)

    @recipe_list = []
    if response["hits"]
      response["hits"].each do |recipe|
        recipe_hash = recipe["recipe"]
        @recipe_list << Recipe.new(recipe_hash)
      end
    end
    return @recipe_list
  end

  def self.find_recipe(recipe_id)
    @recipe_list.each do |recipe|
      if recipe.id == recipe_id
        return recipe
      end
    end

    encoded_uri = URI.encode("#{URL}search?r=http://www.edamam.com/ontologies/edamam.owl#recipe#{recipe_id}&app_id=#{APP_ID}&app_key=#{APP_KEY}")

    response = HTTParty.get(encoded_uri)
    if response.parsed_response == []
      return nil
    else
      recipe_hash = response.first
      one_recipe = Recipe.new(recipe_hash)
      return one_recipe
    end
  end

end
