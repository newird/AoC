import System.IO
import Data.List (isPrefixOf)
import Data.List.Split
import Debug.Trace (trace)
import qualified Data.Map as Map

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

check :: String -> [String] -> Map.Map String Bool -> (Bool, Map.Map String Bool)
check "" _ cache = (True, cache)
check line tokens cache =
    case Map.lookup line cache of
        Just result -> (result, cache)
        Nothing ->
            let
                (result, newCache) = foldl checkToken (False, cache) tokens
                checkToken (found, cache') token
                    | found = (True, cache')
                    | token `isPrefixOf` line =
                        let (res, updatedCache) = check (drop (length token) line) tokens cache'
                        in (res, updatedCache)
                    | otherwise = (found, cache')
                updatedCache = Map.insert line result newCache
            in (result, updatedCache)

checkWithMemo :: String -> [String] -> Bool
checkWithMemo line tokens = fst $ check line tokens Map.empty

count :: String -> Int
count input = length $ filter (`checkWithMemo` tokens) liness
  where
    (tokens, liness) = parse input
