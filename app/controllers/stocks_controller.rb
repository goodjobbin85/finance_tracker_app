class StocksController < ApplicationController
    def list_stocks
        @stocks = StockQuote::Stock.all
        @stocks
    end
    
    def search
        if params[:stock].blank?
            flash.now[:danger] = "Stock cannot be blank"
            render 'users/portfolio'
        else
            @stock = Stock.find_stock(params[:stock])
            flash.now[:danger] = "Please enter valid stock" unless @stock
            render json: @stock
            
        end
        
    end
end
