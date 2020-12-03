defmodule Population do
  defstruct size: 100, chromossomes: []

  def generate_population(size \\ 100) do
    population = %Population{size: size}
    chromossomes = generate_chromossomes(size)

    %{population | chromossomes: chromossomes}
  end

  def best_chromossome(population) do
    population.chromossomes
    |> Enum.sort_by(& &1.fitness)
    |> Enum.at(0)
  end

  def evolute(population, mutations) do
    chromossomes =
      1..mutations
      |> Enum.reduce(population.chromossomes, &evolute_and_replace_chromo/2)

    %Population{population | chromossomes: chromossomes}
  end

  defp generate_chromossomes(size) do
    1..size
    |> Enum.map(fn _ -> Chromossome.generate_chromossome() end)
  end

  defp evolute_and_replace_chromo(_, chromossomes) do
    evolued_chromo = Chromossome.mutate(chromossomes)
    replace_chromossome(chromossomes, evolued_chromo.position, evolued_chromo.chromo)
  end

  defp replace_chromossome(chromossomes, position, chromossome) do
    List.replace_at(chromossomes, position, chromossome)
  end
end
