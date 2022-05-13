defmodule Loop.Location do
  @locations %{
    "Chattanooga" => {20, 70.3, 48},
    "Baltimore" => {54, 97, 69},
    "Florida Keys" => {41, 90.9, 9.3},
    "Savannah" => {45, 87.6, 38.3},
    "Jacksonville" => {35, 86.2, 34.1},
    "Miami" => {49, 94.2, 13.5},
    "Tampa" => {26, 82.4, 23.1},
    "Charleston" => {50, 90.7, 42.4},
    "Myrtle Beach" => {51, 93.7, 46.3},
    "Wilmington" => {57, 98.2, 49.6},
    "Norfolk" => {52, 99.9, 61.5},
    "Washington, DC" => {53, 97.8, 64.8},
    "Atlantic City" => {60, 101.8, 70.7},
    "New York" => {61, 102.6, 74.9},
    "Baton Rouge" => {1, 51.3, 30.7},
    "New Orleans" => {9, 56, 27.3},
    "Vicksburg" => {2, 52.2, 36.8},
    "Greenville" => {3, 53.2, 43.3},
    "Memphis" => {4, 55.3, 49},
    "Cape Girardeau" => {5, 56.4, 55.7},
    "St. Louis" => {6, 53.3, 61},
    "Springfield" => {7, 54.7, 66.2},
    "Bloomington" => {8, 57.4, 70.7},
    "Chicago" => {13, 62.5, 74.4},
    "Holland" => {14, 63.3, 79.5},
    "Traverse City" => {15, 62.8, 84.7},
    "Petoskey" => {16, 65.3, 90.1},
    "Alpena" => {24, 71.1, 89.7},
    "Bay City" => {23, 74.8, 85.8},
    "Detroit" => {22, 76.4, 81.4},
    "Toledo" => {21, 75, 76},
    "Erie" => {30, 81.4, 79.2},
    "Niagara Falls" => {36, 84.6, 84.3},
    "Rochester" => {37, 90.9, 85.2},
    "Syracuse" => {46, 96.2, 84.8},
    "Albany" => {63, 101.6, 84.4},
    "Poughkeepsie" => {62, 102.1, 80},
    "Quebec City" => {48, 99.5, 100.4},
    "Trois Riveres" => {40, 95.5, 95.8},
    "Montreal" => {47, 91.2, 90.9},
    "Ottawa" => {38, 87.3, 91.3},
    "Pembroke" => {39, 83, 93.3},
    "North Bay" => {31, 78.7, 96.5},
    "Blind River" => {32, 72.8, 95.2},
    "Moore Haven" => {34, 89.6, 19},
    "Meridian" => {10, 63.3, 36.1},
    "Tupelo" => {11, 60.9, 41.5},
    "Camden" => {12, 61.4, 50.8},
    "Gulfport" => {17, 61.5, 27},
    "Mobile" => {18, 63.3, 31.2},
    "Huntsville" => {19, 65.4, 45.4},
    "Fort Myers" => {25, 84, 19},
    "Apalachicola" => {27, 78.3, 27.5},
    "Alligator Point" => {28, 73.1, 26.2},
    "Pensacola" => {29, 68.1, 28.4},
    "Marco Island" => {33, 86.6, 14.6},
    "West Palm Beach" => {42, 94, 18.9},
    "Melbourne" => {43, 90.6, 24.7},
    "St. Augustine" => {44, 88.1, 29},
    "Ticonderoga" => {55, 100.9, 89.7},
    "Plattsburgh" => {56, 100.4, 94.6},
    "Morehead City" => {58, 101.7, 53.2},
    "Manteo" => {59, 102.2, 57.6}
  }

  def get_LED(place) do
    Map.get(@locations, place)
  end

  def get_list() do
    Map.to_list(@locations)
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.reduce("", fn x, acc -> acc <> x <> "\n" end)
  end

  def list() do
    Map.to_list(@locations)
  end
end
