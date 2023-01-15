#[cfg(test)]
mod tests {
    use rust_template::*;

    #[test]
    fn verify_sum() {
        assert_eq!(sum(2, 2), 4);
    }

    #[test]
    fn verify_doubler() {
        let a = vec![1, 2, 3, 4, 5];
        assert_eq!(doubler(a), vec![2,4,6,8,10]);
    }
}
