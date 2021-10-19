defmodule Assinante do
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero, key \\ :all) do
    buscar(numero, key)
  end

  defp buscar_enum(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  defp buscar(numero, :all) do
    IO.inspect("buscar todos")

    buscar_todos_assinantes()
    |> buscar_enum(numero)
  end

  defp buscar(numero, :prepago) do
    IO.inspect("buscar pre pago")

    buscar_assinantes_prepagos()
    |> buscar_enum(numero)
  end

  defp buscar(numero, :pospago) do
    IO.inspect("buscar pos pago")

    buscar_assinantes_pospago()
    |> buscar_enum(numero)
  end

  def buscar_assinantes_prepagos(), do: read(:prepago)
  def buscar_assinantes_pospago(), do: read(:pospago)
  def buscar_todos_assinantes(), do: read(:prepago) ++ read(:pospago)

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

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def read(plano) do
    {:ok, assinantes} = File.read(@assinantes[plano])

    assinantes
    |> :erlang.binary_to_term()
  end
end
