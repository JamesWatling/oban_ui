defmodule ObanUi.Repo do
  @repo Application.compile_env(:oban_ui, :repo)

  defmacro __using__(_) do
    quote do
      alias unquote(@repo), as: Repo
      use Scrivener, page_size: 10
    end
  end

  alias ObanUi.DataPage

  # Trick to delegate the needed function to the main app's Repo
  defdelegate one(query), to: @repo
  defdelegate paginate(query, config), to: @repo

  @doc """
  Takes a pagination page (scrivener) and adds information about how the
  data was ordered as well, namely the key and direction
  """
  @spec prepare_page(Scrivener.Page.t(), Keyword.t(), Map.t()) :: DataPage.t()
  def prepare_page(page, [order_by | _rest], _params \\ %{}) do
    {direction, key} = order_by

    DataPage.from_scrivener(page, %{
      ordered_by: key,
      ordered_by_direction: direction
    })
  end
end
