defmodule Loop.Location do
  @locations %{
    "Chattanooga" => {20, 70.3, 48},
    "Annapolis" => {54, 97, 69},
    "Key West" => {41, 90.9, 9.3},
    "Savannah" => {45, 87.6, 38.3},
    "Fernandina Beach" => {35, 86.2, 34.1},
    "Miami" => {49, 94.2, 13.5},
    "Clearwater" => {26, 82.4, 23.1},
    "Charleston" => {50, 90.7, 42.4},
    "Myrtle Beach" => {51, 93.7, 46.3},
    "Wilmington" => {57, 98.2, 49.6},
    "Norfolk" => {52, 99.9, 61.5},
    "Deltaville" => {53, 97.8, 64.8},
    "Cape May" => {60, 101.8, 70.7},
    "Atlantic City" => {61, 102.6, 74.9},
    "Baton Rouge" => {1, 51.3, 30.7},
    "New Orleans" => {9, 56, 27.3},
    "Vicksburg" => {2, 52.2, 36.8},
    "Greenville" => {3, 53.2, 43.3},
    "Memphis" => {4, 55.3, 49},
    "Cape Girardeau" => {5, 56.4, 55.7},
    "St. Louis" => {6, 53.3, 61},
    "Peoria" => {7, 54.7, 66.2},
    "Hennepin" => {8, 57.4, 70.7},
    "Chicago" => {13, 62.5, 74.4},
    "Grand Haven" => {14, 63.3, 79.5},
    "Manistee" => {15, 62.8, 84.7},
    "Petoskey" => {16, 65.3, 90.1},
    "Alpena" => {24, 71.1, 89.7},
    "Port Hope" => {23, 74.8, 85.8},
    "Detroit" => {22, 76.4, 81.4},
    "Toledo" => {21, 75, 76},
    "Cleveland" => {30, 81.4, 79.2},
    "Buffalo" => {36, 84.6, 84.3},
    "Rochester" => {37, 90.9, 85.2},
    "Syracuse" => {46, 96.2, 84.8},
    "Albany" => {63, 101.6, 84.4},
    "New York City" => {62, 102.1, 80},
    "Montreal" => {48, 99.5, 100.4},
    "Ottawa" => {40, 95.5, 95.8},
    "Kingston" => {47, 91.2, 90.9},
    "Peterborough" => {38, 87.3, 91.3},
    "Britt" => {39, 83, 93.3},
    "Drummond" => {31, 78.7, 96.5},
    "Mackinaw City" => {32, 72.8, 95.2},
    "Lake Okeechobee" => {34, 89.6, 19},
    "Columbus" => {10, 63.3, 36.1},
    "Fulton" => {11, 60.9, 41.5},
    "Grand Rivers" => {12, 61.4, 50.8},
    "Gulfport" => {17, 61.5, 27},
    "Demopolis" => {18, 63.3, 31.2},
    "Huntsville" => {19, 65.4, 45.4},
    "Cape Coral" => {25, 84, 19},
    "Apalachicola" => {27, 78.3, 27.5},
    "Miramar Beach" => {28, 73.1, 26.2},
    "Pensacola" => {29, 68.1, 28.4},
    "Marco Island" => {33, 86.6, 14.6},
    "West Palm Beach" => {42, 94, 18.9},
    "New Smyrna Beach" => {43, 90.6, 24.7},
    "St. Augustine" => {44, 88.1, 29},
    "Fort Edward" => {55, 100.9, 89.7},
    "Burlington" => {56, 100.4, 94.6},
    "Morehead City" => {58, 101.7, 53.2},
    "Dismal Swamp" => {59, 102.2, 57.6}
  }

  # Returns location map in form of a list
  def make_list() do
    Map.to_list(@locations)
  end

  # Takes input and translates place names to LED numbers
  def get_list(string) do
    String.split(string, ",")
    |> Enum.map(fn x -> String.trim(x) end)
    |> Enum.map(fn x -> get_LED_number(x) end)
  end

  defp get_LED_number(place) do
    {num, _x, _y} = Map.get(@locations, place)
    num
  end
end
