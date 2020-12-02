defmodule Chromossome do
  defstruct [:fitness, genes: [], generation_number: 1]

  def generate_chromossome(genes_size \\ 100) do
    chromossome = %Chromossome{generation_number: 1}

    genes =
      1..genes_size
      |> Enum.map(fn _ -> Gene.generate_gene() end)

    fitness = calculate_fitness(genes)

    chromossome = %{chromossome | genes: genes, fitness: fitness}
    chromossome
  end

  def mutate(chromossomes, chromossomes_size) do
    first_chosen_chromo_position =
      :random.uniform(chromossomes_size - 1)
      |> round()

    second_chosen_chromo_position =
      :random.uniform(chromossomes_size - 1)
      |> round()

    first_chosen_chromo = Enum.at(chromossomes, first_chosen_chromo_position)
    second_chosen_chromo = Enum.at(chromossomes, second_chosen_chromo_position)

    positions =
      1..10
      |> Enum.map(fn _ -> :random.uniform(100 - 1) end)
      |> Enum.map(&round(&1))
      |> Enum.map(fn x -> get_better_chromossome(first_chosen_chromo, second_chosen_chromo, x) end)

    positions
  end

  defp calculate_fitness(genes) do
    fitness =
      genes
      |> Enum.map(fn x -> x.weight end)
      |> Enum.sum()

    fitness
  end

  def get_better_chromossome(first_chromo, second_chromo, position) do
    first_chromo_gene = first_chromo.genes |> Enum.at(position)
    second_chromo_gene = second_chromo.genes |> Enum.at(position)

    if first_chromo_gene.weight < second_chromo_gene.weight do
      %{position: position, gene: first_chromo_gene}
    else
      %{position: position, gene: second_chromo_gene}
    end
  end
end
