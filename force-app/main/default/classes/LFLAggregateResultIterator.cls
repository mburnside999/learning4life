public class LFLAggregateResultIterator implements Iterator<AggregateResult> {
  private List<AggregateResult> aggresults;
  private Integer currentIndex;

  public LFLAggregateResultIterator(List<AggregateResult> aggresults) {
    this.aggresults = aggresults;
    this.currentIndex = 0;
  }

  public Boolean hasNext() {
    return currentIndex < aggresults.size();
  }

  public AggregateResult next() {
    if (hasNext()) {
      return aggresults[currentIndex++];
    } else {
      throw new NoSuchElementException('Iterator has no more elements.');
    }
  }
}
