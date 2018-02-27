defmodule PhoenixAndElmWeb.Schema do
  use Absinthe.Schema
  alias PhoenixAndElm.AddressBook.ContactResolver
  import_types(PhoenixAndElmWeb.Schema.Types)

  query do
    @desc "The list of contacts in the address book"
    field :contacts, type: :paginated do
      @desc "The page number for pagination"
      arg(:page, :integer)
      # arg(:page_size, :integer)
      @desc "The query for searching contacts"
      arg(:search, :string)
      resolve(&ContactResolver.search_contacts/3)
    end
  end
end