#include "unity.h"
#include "Calc.h"

void setUp()
{

}

void tearDown()
{

}

void test_subtract()
{
    int output = sub(20, 10);
    TEST_ASSERT_EQUAL(10, output);
}

void test_multiply()
{
    int output = mul(2, 10);
    TEST_ASSERT_EQUAL(20, output);
}

int main(void)
{
    UNITY_BEGIN();

    RUN_TEST(test_subtract);
	RUN_TEST(test_multiply);

    UNITY_END();

    return 0;
}
