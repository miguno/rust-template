/// Computes the sum of two numbers.
///
/// For demonstration purposes only. Intentionally does not check for integer
/// overflow/underflow.
#[must_use]
pub const fn sum(a: i32, b: i32) -> i32 {
    a + b
}

/// Doubles the numbers in the vector.
///
/// For demonstration purposes only. Intentionally does not check for integer
/// overflow/underflow.
#[must_use]
pub fn doubler(v: Vec<i32>) -> Vec<i32> {
    v.into_iter().map(|x| x * 2).collect()
}
