defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  setup do
    File.write(@assinantes[:prepago], :erlang.term_to_binary([]))
    File.write(@assinantes[:pospago], :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm(@assinantes[:prepago])
      File.rm(@assinantes[:pospago])
    end)
  end

  describe "testes responsáveis para cadastro de assinantes" do
    test "deve retornar estrutura de assinantes" do
      assert %Assinante{nome: "André", numero: "123", cpf: "456", plano: :prepago}.nome == "André"
    end

    test "criar uma conta pré" do
      assert Assinante.cadastrar("André", "123", "456") ==
               {:ok, "Assinante André cadastrado com sucesso"}
    end

    test "deve retornar erro dizendo que assinantes já está cadastrado" do
      Assinante.cadastrar("André", "123", "456")
      assert Assinante.cadastrar("André", "123", "456") ==
               {:error, "Assinante já cadastrado com esse número"}
    end
  end

  describe "testes responsáveis por busca de assinantes" do
    test "busca pós" do
      Assinante.cadastrar("André", "123", "456", :pospago)

      assert Assinante.buscar_assinante("123", :pospago).nome == "André"
    end

    test "busca pré" do
      Assinante.cadastrar("André", "123", "456", :prepago)

      assert Assinante.buscar_assinante("123", :prepago).nome == "André"
    end
  end

  describe "delete" do
    test "deve deletar o assinante" do
      Assinante.cadastrar("André", "123", "456", :pospago)
      Assinante.cadastrar("João", "456", "888", :pospago)
      assert Assinante.deletar("123") == {:ok, "Assinante André deletado"}
    end
  end
end
