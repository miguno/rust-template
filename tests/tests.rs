#[cfg(test)]
mod tests {
    use rust_template::sum;

    #[test]
    fn verify_sum() {
        assert_eq!(sum(2, 2), 4);
    }
}
