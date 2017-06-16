defmodule Formex.Controller do
  alias Formex.Form
  alias Formex.Validator

  defmacro __using__(_) do
    quote do
      import Formex.Builder
      import Formex.Controller
    end
  end

  @moduledoc """
  Helpers for controller. Imports `Formex.Builder`.

  # Installation:

  `web/web.ex`
  ```
  def controller do
    quote do
      use Formex.Controller
    end
  end
  ```

  # Usage

  ```
  def new(conn, _params) do
    form = create_form(App.ArticleType, %Article{})
    render(conn, "new.html", form: form)
  end
  ```

  ```
  def create(conn, %{"article" => article_params}) do
    App.ArticleType
    |> create_form(%Article{}, article_params)
    |> handle_form
    |> case do
      {:ok, article} ->
        # do something with a new article struct
      {:error, form} ->
        # display errors
        render(conn, "index.html", form: form)
    end
  end
  ```

  For usage with Ecto see `Formex.Ecto.Controller`
  """

  @doc """
  Validates form. When is valid, returns `{:ok, form.new_struct}`, otherwise, `{:error, form}` with
  validation errors inside `form.errors`
  """
  @spec handle_form(Form.t) :: {:ok, Map.t} | {:error, Form.t}
  def handle_form(form) do
    form = form |> Validator.validate()

    if form.valid? do
      {:ok, form.new_struct}
    else
      {:error, form}
    end
  end

end
