/// Computes the sum of two numbers.
pub fn sum(a: i32, b: i32) -> i32 {
    a + b
}

/// Doubles the numbers in the vector.
pub fn doubler(v: Vec<i32>) -> Vec<i32> {
    v.into_iter().map(|x| x * 2).collect()
}
