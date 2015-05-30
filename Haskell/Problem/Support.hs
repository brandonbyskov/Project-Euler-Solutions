module Problem.Support where

import Data.Char (digitToInt)

--Prime functions

primes :: [Int]
primes = 2:[x::Int | x <- tail divisorList, isPrime x]

-- This prime number generator is much faster, but is memory expensive.
primes' :: [Int]
primes' = 2:[x::Int | x <- tail divisorList, not (hasPrimeDivisors x (floor (sqrt (fromIntegral (x)))) primes')]
  where
    hasPrimeDivisors :: Int -> Int -> [Int] -> Bool
    hasPrimeDivisors x max pList
      | head pList > max = False
      | otherwise = (isDivisible (head pList) x) || (hasPrimeDivisors x max (tail pList))

divisorList :: [Int]
divisorList = 2:3:5:(tail (concatMap (\x -> fmap (x+) primesShortList) [0,30..]))
  where
    primesShortList ::[Int]
    primesShortList = [1,7,11,13,17,19,23,29]

isPrime :: (Integral a) => a -> Bool
isPrime x
  | x < 5           = if x == 2 || x == 3 then True else False
  | even x          = False
  | isDivisible 3 x = False
  | otherwise       = not (hasDivisors 5 (floor (sqrt (fromIntegral x))) x)
  where
    hasDivisors :: (Integral a) => a -> a -> a -> Bool
    hasDivisors divisor max x
      | divisor > max = False
      | otherwise     = isDivisible divisor x || isDivisible (divisor + 2) x || hasDivisors (divisor+6) max x

getNextPrime :: (Integral a) => a -> a
getNextPrime x
  | x < 2     = 2
  | even x    = if isPrime (x+1) then x+1 else getNextPrime (x+1)
  | otherwise = if isPrime (x+2) then x+2 else getNextPrime (x+2)

--End Prime functions

-- True if x is divisible by d
isDivisible :: (Integral a) => a -> a -> Bool
isDivisible d x = (x `mod` d) == 0

numDivisors :: (Integral a) => a -> a
numDivisors x
  | x <= 1    = if x == 1 then 1 else 0
  | otherwise = 2 + addDivisors 2 (floor (sqrt (fromIntegral x))) x
  where
    addDivisors :: (Integral a) => a -> a -> a -> a
    addDivisors d max x
      | d >= max        = if d*d == x then 1 else 0
      | isDivisible d x = 2 + addDivisors (d+1) max x
      | otherwise       = addDivisors (d+1) max x

isPalindrome :: (Integral a, Show a) => a -> Bool
isPalindrome x 
  | x < 0 = False
  | otherwise = (show x) == reverse (show x)

toDigits :: (Integral a) => a => [Int]
toDigits x = fmap digitToInt (show (toInteger x))
