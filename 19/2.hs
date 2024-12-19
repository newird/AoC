import System.IO
import Data.List (isPrefixOf)
import Data.List.Split
import Debug.Trace (trace)
import qualified Data.Map as Map
import Data.Map (Map)

main::IO ()
main = do
  let  filename = "1.in"
  content <- readFile filename
  let ans = count content
  print  ans


parse :: String -> ([String], [String])
parse input = (tokens , liness)
  where
  [part1 , part2] = splitOn "\n\n" input
  tokens = splitOn ", " part1
  liness = lines part2

check :: String -> [String] -> Map.Map String Int -> (Int , Map.Map String Int)
check "" _ cache = (1, cache)

check line tokens cache =
    case Map.lookup line cache of
        Just result -> (result, cache)
        Nothing ->
            let
                (result, newCache) = foldl checkToken (0, cache) tokens
                checkToken (count, cache') token
                    | token `isPrefixOf` line =
                        let (res, updatedCache) = check (drop (length token) line) tokens cache'
                        in (count + res, updatedCache)
                    | otherwise = (count, cache')
                updatedCache = Map.insert line result newCache
            in (result, updatedCache)


checkWithMemo :: String -> [String] -> Int
checkWithMemo line tokens = fst $ check line tokens Map.empty

count :: String -> Int
count input = sum $ map (`checkWithMemo` tokens) liness
  where
    (tokens, liness) = parse input
