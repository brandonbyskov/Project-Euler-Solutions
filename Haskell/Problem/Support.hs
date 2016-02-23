module Problem.Support where

import Data.Char (digitToInt)
import Data.List

--Prime functions

primes :: [Int]
primes = 2:[x | x <- tail divisorList, isPrime x]

-- This prime number generator is much faster, but is memory expensive.
primes' :: [Int]
primes' = let pList = drop 3 primes'
          in 2:3:5:7:[x | x <- drop 4 divisorList, not (hasPrimeDivisors x pList)]

hasPrimeDivisors :: Int -> [Int] -> Bool
hasPrimeDivisors x pList
  | head pList > root = False
  | otherwise         = (isDivisible (head pList) x) || (hasPrimeDivisors x (tail pList))
  where
    root = sqrRoot x

divisorList :: [Int]
divisorList = 2:3:5:(tail (concatMap (\x -> fmap (x+) primesShortList) [0,30..]))
  where
    primesShortList :: [Int]
    primesShortList = [1,7,11,13,17,19,23,29] 

isPrime :: Int -> Bool
isPrime x
  | x < 5     = x == 2 || x == 3
  | otherwise = not . or . fmap (\a -> isDivisible a x) . takeWhile (<= sqrRoot x) $ divisorList

getNextPrime :: Int -> Int
getNextPrime x
  | x < 2     = 2
  | even x    = if isPrime (x+1) then x+1 else getNextPrime (x+1)
  | otherwise = if isPrime (x+2) then x+2 else getNextPrime (x+2)

--End Prime functions

-- generates a sorted list of divisors
divisors :: Int -> [Int]
divisors x = generateDivisors 1 []
  where
    generateDivisors :: Int -> [Int] -> [Int]
    generateDivisors d upperList
      | d == sqrRoot x  = if isDivisible d x
                            then if d*d == x 
                                   then d:upperList
                                   else d:(x`div`d):upperList
                            else upperList
      | isDivisible d x = d:generateDivisors (d+1) ((x`div`d):upperList)
      | otherwise       = generateDivisors (d+1) upperList

-- True if x is divisible by d
isDivisible :: (Integral a) => a -> a -> Bool
isDivisible d x = (x `mod` d) == 0

numDivisors :: (Integral a) => a -> a
numDivisors x
  | x <= 1    = if x == 1 then 1 else 0
  | otherwise = 2 + addDivisors 2 (sqrRoot x) x
  where
    addDivisors :: (Integral a) => a -> a -> a -> a
    addDivisors d root x
      | d >= root       = if d*d == x then 1 else 0
      | isDivisible d x = 2 + addDivisors (d+1) root x
      | otherwise       =     addDivisors (d+1) root x

-- Factorial grows very quickly. Use type Integer for n > 20
factorial :: (Integral a) => a -> a
factorial n = foldl' (*) 1 [2..n]

isPalindrome :: (Integral a, Show a) => a -> Bool
isPalindrome x 
  | x < 0 = False
  | otherwise = (show x) == reverse (show x)

isPandigital :: Integral a => a -> Bool
isPandigital x = [1..9] == (intersect [1..9] (toDigits x))

sqrRoot :: (Integral a) => a -> a
sqrRoot = floor . sqrt . fromIntegral

toDigits :: (Integral a) => a => [Int]
toDigits = fmap digitToInt . show . toInteger
