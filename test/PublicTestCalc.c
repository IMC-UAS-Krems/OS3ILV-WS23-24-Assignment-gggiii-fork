#include "unity.h"
#include "Calc.h"

void setUp(void)
{

}

void tearDown(void)
{

}

void test_subtract(void)
{
    int output = sub(20, 10);
    TEST_ASSERT_EQUAL(10, output);
}

void test_multiply(void)
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
