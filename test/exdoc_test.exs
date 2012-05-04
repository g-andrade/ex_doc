Code.require_file "../test_helper", __FILE__

defmodule ExDocTest do
  use ExUnit.Case, sync: true

  def setup_all do
    :file.set_cwd("test")
    :file.make_dir(output_dir)
  end

  def teardown_all do
    System.cmd("rm -rf #{output_dir}")
    :file.set_cwd("..")
  end

  defp output_dir do
    File.expand_path "output"
  end

  test "generate_docs generates the html file with the documentation" do
    ExDoc.generate_docs File.expand_path("tmp")
    assert File.regular?("#{output_dir}/CompiledWithDocs.html")
    assert File.regular?("#{output_dir}/CompiledWithDocs.Nested.html")
  end

  test "generate_docs accepts relative directories" do
    ExDoc.generate_docs "tmp"
    assert File.regular?("#{output_dir}/CompiledWithDocs.html")
    assert File.regular?("#{output_dir}/CompiledWithDocs.Nested.html")
  end

  test "generate_docs generates the panel index html file with all modules" do
    ExDoc.generate_docs File.expand_path("tmp")

    content = File.read!("#{output_dir}/module_list.html")
    assert content[%r/<li>.*'CompiledWithDocs\.html'.*CompiledWithDocs.*<\/li>/m]
    assert content[%r/<li>.*'CompiledWithDocs\.html#example\/0'.*example\/0.*<\/li>/m]
    assert content[%r/<li>.*'CompiledWithDocs\.html#example_1\/0'.*example_1\/0.*<\/li>/m]
    assert content[%r/<li>.*'CompiledWithDocs\.html#example_without_docs\/0'.*example_without_docs\/0.*<\/li>/m]
    assert content[%r/<li>.*'CompiledWithDocs.Nested\.html'.*Nested.*<\/li>/m]
    assert content[%r/<li>.*'CompiledWithoutDocs\.html'.*CompiledWithoutDocs.*<\/li>/m]
    assert content[%r/<li>.*'ExDocTest\.Nested\.html'.*ExDocTest\.Nested.*<\/li>/m]
    assert content[%r/<li>.*'ExDocTest\.Nested\.html#example\/2'.*example\/2.*<\/li>/m]
  end

  test "generate_docs generates in specified output directory" do
    ExDoc.generate_docs "tmp", "#{output_dir}/docs"

    assert :filelib.is_file("#{output_dir}/docs/CompiledWithDocs.html")
  end
end
