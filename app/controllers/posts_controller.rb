class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    #@posts = Post.all
    # only active subscribers can see premium posts
    if current_user.subscription_status == "active"
      @posts = Post.all
    else
      @posts = Post.free
    end
  end

  def show
    # only active subscribers can see premium posts
    if @post.premium? && current_user.subscription_status != "active"
      redirect_to posts_path, alert: "Post for premium subscribers"
    end
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post was successfully destroyed."
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :premium)
    end
end
