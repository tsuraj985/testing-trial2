global class AccountGenerator implements Iterator<Account> {
  Integer Counter;
  public AccountGenerator(Integer GeneratorLimit) {
    Counter = GeneratorLimit;
  }
  global boolean hasNext() {
    return Counter > 0;
  }
  global Account next() {
    return new Account(Name='Test '+Counter--);
  }
}