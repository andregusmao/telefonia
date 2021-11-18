defmodule Assinante do
  @moduledoc """
  Módulo de assinantes para cadastro de assinantes `prepago` e `pospago`

  A função mais utilizada é a função `cadastrar/4`
  """
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)

  defp buscar_enum(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  defp buscar(numero, :all), do: buscar_enum(buscar_todos_assinantes(), numero)

  defp buscar(numero, :prepago), do: buscar_enum(buscar_assinantes_prepagos(), numero)

  defp buscar(numero, :pospago), do: buscar_enum(buscar_assinantes_pospago(), numero)

  def buscar_todos_assinantes(), do: read(:prepago) ++ read(:pospago)
  def buscar_assinantes_prepagos(), do: read(:prepago)
  def buscar_assinantes_pospago(), do: read(:pospago)

  @doc """
  Função para cadastrar assinante seja ele `prepago` ou `pospago`

  ## Parâmetros da função

  - nome: nome do assinante
  - número: telefone do assinante
  - cpf: documento do assinante
  - plano: (opcional) o valor padrão é `prepago`

  ## Exemplo

      iex> Assinante.cadastrar("André", "123", "456")
      {:ok, "Assinante André cadastrado com sucesso"}

  ## Informações adicionais

  - caso o número já exista ele informará um erro

  ## Exemplo

      iex> Assinante.cadastrar("André", "123", "456")
      {:ok, "Assinante André cadastrado com sucesso"}
      iex> Assinante.cadastrar("André", "123", "456")
      {:error, "Assinante já cadastrado com esse número"}

  """
  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    case buscar_assinante(numero) do
      nil ->
        (read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}])
        |> :erlang.term_to_binary()
        |> write(plano)

        {:ok, "Assinante #{nome} cadastrado com sucesso"}

      _assinante ->
        {:error, "Assinante já cadastrado com esse número"}
    end
  end

  defp write(lista_assinantes, plano), do: File.write!(@assinantes[plano], lista_assinantes)

  def read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assinantes} ->
        assinantes
        |> :erlang.binary_to_term()

      {:error, :enooent} ->
        {:error, "Arquivo inválido"}
    end
  end

  def deletar(numero) do
    assinante = buscar_assinante(numero)
    result_delete = buscar_todos_assinantes()
    |> List.delete(assinante)
    |> :erlang.term_to_binary()
    |> write(assinante.plano)
    {result_delete, "Assinante #{assinante.nome} deletado"}

  end
end
