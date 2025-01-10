import { test } from "./foobar_ts";

it("should return greater than 1", () => {
  expect(test(2)).toEqual("greater than 1");
});
