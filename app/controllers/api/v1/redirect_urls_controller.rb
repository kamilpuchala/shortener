module Api
  module V1
    class RedirectUrlsController < ApplicationController
      def index
        redirect_urls = RedirectUrl.all
        render json:  redirect_urls_presenter(redirect_urls)
      end
      
      def show
        redirect_url = RedirectUrl.find(params[:id])
        
        render json: redirect_url_presenter(redirect_url)
      end
      
      
      def create
        redirect_url = ::RedirectUrls::Create.new(original_url: redirect_url_params[:original_url]).call
       
        if redirect_url.errors.empty?
           render json: redirect_url_presenter(redirect_url), status: :created
        else
           render json: { errors: redirect_url.errors.full_messages }, status: :unprocessable_entity
        end
      end
   
      private
      
      def redirect_url_params
        params.require(:redirect_url).permit(:original_url)
      end
      
      def redirect_url_presenter(redirect_url)
        ::Api::V1::RedirectUrlPresenter.new(redirect_url).to_hash
      end
      
      def redirect_urls_presenter(redirect_urls)
        redirect_urls.map do |redirect_url|
          redirect_url_presenter(redirect_url)
        end
      end
    end
  end
end

