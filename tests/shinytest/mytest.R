app <- ShinyDriver$new("../../")
app$snapshotInit("mytest")

app$setInputs(state = "Detroit @  LA")
app$setInputs(txt1 = "100")
app$setInputs(txt2 = "-135")
app$snapshot()

output <- app$getValue(name = "txtout")
expect_equal(output, "100 -135")
