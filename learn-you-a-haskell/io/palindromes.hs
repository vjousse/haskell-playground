import Data.Char

main = interact respondPalindromes

respondPalindromes = unlines . map (\xs -> if isPalindrome xs then "palindrome" else "not a palindrome") . lines
    where   isPalindrome xs = (map toUpper xs) == (reverse $ map toUpper xs)
