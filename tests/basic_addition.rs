#[test]
#[allow(non_snake_case)]
fn BasicAddition() {
    assert_eq!(hello::add(2, 3), 5);
    assert_eq!(hello::add(-2, -3), -5);
    assert_eq!(hello::add(0, 0), 0);
}
