defmodule User.UserEntity do
  @moduledoc """
  Documentation for `UserEntity`.
  """

  alias UUID
  alias User.UserEntity
  alias User.ValueObjects.EmailValueObject
  alias User.ValueObjects.NameValueObject
  alias User.ValueObjects.PasswordValueObject
  alias Common.ValueObjects.IdValueObject
  alias Common.Errors.DomainError

  defstruct name: nil,
            email: nil,
            password: nil,
            id: nil

  @type create_dto() :: %{
          name: binary(),
          email: binary(),
          password: binary()
        }

  @type auth_dto :: %{
          email: binary(),
          password: binary()
        }

  @type t() :: %UserEntity{
          name: NameValueObject.t(),
          email: EmailValueObject.t(),
          password: PasswordValueObject.t(),
          id: IdValueObject.t()
        }

  @type ok() :: {:ok, UserEntity.t()}

  @type error() :: {:error, DomainError.t()}

  @spec new(create_dto()) :: ok() | error()
  def new(create_dto) when is_map(create_dto) do
    with {:ok, name_value_object} <- NameValueObject.new(create_dto.name),
         {:ok, email_value_object} <- EmailValueObject.new(create_dto.email),
         {:ok, password_value_object} <- PasswordValueObject.new(create_dto.password),
         {:ok, id_value_object} <- IdValueObject.new(UUID.uuid4()) do
      {
        :ok,
        %UserEntity{
          name: name_value_object,
          email: email_value_object,
          password: password_value_object,
          id: id_value_object
        }
      }
    else
      {:error, domain_error} -> {:error, domain_error}
    end
  end

  def new(_) do
    {:error, DomainError.new("Invalid input data")}
  end

  @spec validate_password(UserEntity.t(), binary()) :: {:ok, true} | error()
  def validate_password(user_entity, password) when is_struct(user_entity) and is_binary(password) do
    with user_entity <- Map.from_struct(user_entity),
         true <- user_entity[:password] != nil,
         true <- is_struct(user_entity[:password]),
         password_value_object <- Map.from_struct(user_entity[:password]),
         true <- password_value_object[:value] != nil,
         result_validate <- Bcrypt.verify_pass(password, password_value_object[:value]),
         false <- result_validate == false do
      {:ok, true}
    else
      false -> {:error, DomainError.new("Invalid input data")}
      true -> {:error, DomainError.new("Wrong password")}
    end
  end

  def validate_password(_, _) do
    {:error, DomainError.new("Invalid input data")}
  end
end
