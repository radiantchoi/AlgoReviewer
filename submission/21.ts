// LeetCode No.21 Merge Two Sorted Lists

// Definition for singly-linked list.
class ListNode {
  val: number;
  next: ListNode | null;
  constructor(val?: number, next?: ListNode | null) {
    this.val = val === undefined ? 0 : val;
    this.next = next === undefined ? null : next;
  }
}

function mergeTwoLists(
  list1: ListNode | null,
  list2: ListNode | null,
): ListNode | null {
  if (!list1 && !list2) {
    return null;
  } else if (list1 && !list2) {
    return list1;
  } else if (!list1 && list2) {
    return list2;
  }

  let result = list1.val < list2.val ? list1 : list2;
  let answer = result;

  if (result == list1) {
    list1 = list1.next;
  } else {
    list2 = list2.next;
  }

  while (list1 && list2) {
    if (list1.val < list2.val) {
      result.next = list1;
      list1 = list1.next;
    } else {
      result.next = list2;
      list2 = list2.next;
    }

    result = result.next;
  }

  if (list1) {
    result.next = list1;
  }

  if (list2) {
    result.next = list2;
  }

  return answer;
}
