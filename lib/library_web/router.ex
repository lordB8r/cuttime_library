defmodule LibraryWeb.Router do
  use LibraryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LibraryWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LibraryWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/books", BookController
    resources "/members", MemberController
    post "/members/return/:member_id/:book_id", MemberController, :return
    get "/members/checkout/:member_id", MemberController, :list_books
    post "/members/checkout/:member_id/:book_id", MemberController, :checkout

    live "/upload_live", UploadLive
    live "/checkout_live", CheckoutLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", LibraryWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:library, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LibraryWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
