defmodule Population do
  defstruct size: 100, chromossomes: []

  def generate_population(size \\ 100) do
    population = %Population{size: size}
    chromossomes = generate_chromossomes(size)

    %{population | chromossomes: chromossomes}
  end

  def best_chromossome(population) do
    Enum.sort_by(population.chromossomes, & &1.fitness)
    |> Enum.at(0)
  end

  defp concat_result_stream(results_stream) do
    Enum.reduce(results_stream, [], fn {:ok, worker_result}, acc ->
      Enum.concat(acc, worker_result)
    end)
  end

  defp evolution_mode(m) when m === :parallel,
    do: fn chunks, mutations_by_chunk ->
      Task.async_stream(chunks, fn c -> evolute_chromo_chunk(c, mutations_by_chunk) end)
      |> concat_result_stream()
    end

  defp evolution_mode(m) when m === :linear,
    do: fn chunks, mutations_by_chunk ->
      Enum.map(chunks, fn c -> evolute_chromo_chunk(c, mutations_by_chunk) end)
      |> Enum.flat_map(& &1)
    end

  defp evolution_mode(_), do: raise("Invalid evolution mode")

  def evolute(population, mutations, chunks_count, mode \\ :parallel) do
    chunks = Chromossome.chunk(population.chromossomes, chunks_count)
    mutations_by_chunk = div(mutations, chunks_count)
    now = DateTime.utc_now()

    evolution_mode_function = evolution_mode(mode)
    chromossomes = evolution_mode_function.(chunks, mutations_by_chunk)

    mutation_duration_time = DateTime.diff(DateTime.utc_now(), now, :millisecond)

    %{
      population: %Population{population | chromossomes: chromossomes},
      spent_time: mutation_duration_time
    }
  end

  def evolute_chromo_chunk(chromossomes, mutations) do
    Enum.reduce(1..mutations, chromossomes, &evolute_and_replace_chromo/2)
  end

  defp generate_chromossomes(size) do
    Enum.map(1..size, fn _ -> Chromossome.generate_chromossome() end)
  end

  defp evolute_and_replace_chromo(_, chromossomes) do
    evolued_chromo = Chromossome.mutate(chromossomes)
    replace_chromossome(chromossomes, evolued_chromo.position, evolued_chromo.chromo)
  end

  defp replace_chromossome(chromossomes, position, chromossome) do
    List.replace_at(chromossomes, position, chromossome)
  end
end
