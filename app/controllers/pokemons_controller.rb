# frozen_string_literal: true

require 'will_paginate/array'

class PokemonsController < ApplicationController
  def index
     @pokemons = Pokemon.all.paginate(page: params[:page], per_page: 10)
  end

  def show
    @pokemon = Pokemon.find(params[:id])
  rescue StandardError => e
    logger.info e
    redirect_to root_path
  end

  def new
    @pokemon = Pokemon.new # Needed to instantiate the form_with
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)
    if @pokemon.save
      params[:types].shift
      params[:types].each do |id|
        type = Type.find(id.to_i)
        # byebug
        @pokemon.types << type unless @pokemon.types.include?(type)
      end
      params[:abilities].shift
      params[:abilities].each do |id|
        ability = Ability.find(id.to_i)
        @pokemon.abilities << ability unless @pokemon.abilities.include?(ability)
      end
    redirect_to pokemon_path(@pokemon),
    flash: { notice: 'Your Pokemon was created' }
    else
      render :new,
      flash: { alert: 'It was not possible to create the pokemon' }
    end
  end

  def edit
    @pokemon = Pokemon.find(params[:id])
  end

  def update
    @pokemon = Pokemon.find(params[:id])
    @pokemon.update(pokemon_params)
    redirect_to pokemon_path(@pokemon),
    flash: { notice: 'Your Pokemon was edited' }
  end

  def destroy
    @pokemon = Pokemon.find(params[:id])
    @pokemon.destroy
    redirect_to pokemons_path, flash: { notice: 'Your Pokemon was deleted' }
  end

  private

  def pokemon_params
    params.require(:pokemon).permit(:name, :description, :weight, :next_evolution, :image_url, types: [], abilities: [])
  end
end
