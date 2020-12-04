defmodule Chromossome do
  defstruct [:fitness, genes: [], generation_number: 1]

  @default_chromossome_genes_size 100
  @default_mutated_genes_qty 10

  def generate_chromossome do
    chromossome = %Chromossome{generation_number: 1}

    genes = generate_genes()
    fitness = calculate_fitness(genes)

    %{chromossome | genes: genes, fitness: fitness}
  end

  defp generate_genes do
    1..@default_chromossome_genes_size
    |> Enum.map(fn _ -> Gene.generate_gene() end)
  end

  def chunk(chromossomes, chunks) do
    Enum.chunk_every(chromossomes, chunks)
  end

  def mutate(chromossomes) when length(chromossomes) == 0, do: []

  def mutate(chromossomes) do
    chromossomes_size = length(chromossomes)
    first_chromo_position = choose_random_chromo_position(chromossomes_size)
    second_chromo_position = choose_random_chromo_position(chromossomes_size)

    first_chromo = chromossome_at(chromossomes, first_chromo_position)
    second_chromo = chromossome_at(chromossomes, second_chromo_position)

    best_genes = get_best_genes(first_chromo.chromo, second_chromo.chromo)
    worse_chromo = worse_chromossome(first_chromo, second_chromo)
    upgraded_genes = replace_genes(worse_chromo.chromo, best_genes)
    upgraded_genes_fitness = calculate_fitness(upgraded_genes)

    upgraded_chromossome = %Chromossome{
      fitness: upgraded_genes_fitness,
      genes: upgraded_genes,
      generation_number: worse_chromo.chromo.generation_number + 1
    }

    %{position: worse_chromo.position, chromo: upgraded_chromossome}
  end

  defp chromossome_at(chromossomes, position) do
    Enum.at(chromossomes, position)
    |> (&%{chromo: &1, position: position}).()
  end

  defp get_best_genes(first_chosen_chromo, second_chosen_chromo) do
    1..@default_mutated_genes_qty
    |> Enum.map(fn _ -> :rand.uniform(@default_chromossome_genes_size - 1) end)
    |> Enum.map(&round(&1))
    |> Enum.map(&get_best_gene(first_chosen_chromo, second_chosen_chromo, &1))
  end

  defp worse_chromossome(first_chromo, second_chromo) do
    if first_chromo.chromo.fitness > second_chromo.chromo.fitness do
      first_chromo
    else
      second_chromo
    end
  end

  defp replace_genes(chromossome, best_genes) do
    Enum.reduce(best_genes, chromossome.genes, fn x, acc ->
      List.replace_at(acc, x.position, x.gene)
    end)
  end

  defp choose_random_chromo_position(size) do
    :rand.uniform(size - 1) |> round()
  end

  defp calculate_fitness(genes) do
    genes
    |> Enum.map(& &1.weight)
    |> Enum.sum()
  end

  def get_best_gene(first_chromo, second_chromo, position) do
    first_chromo_gene = first_chromo.genes |> Enum.at(position)
    second_chromo_gene = second_chromo.genes |> Enum.at(position)

    if first_chromo_gene.weight < second_chromo_gene.weight do
      %{position: position, gene: first_chromo_gene}
    else
      %{position: position, gene: second_chromo_gene}
    end
  end
end
