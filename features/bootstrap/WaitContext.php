<?php
/**
 * Created by PhpStorm.
 * User: Riccardo De Leo
 */

use Behat\Mink\Driver\Selenium2Driver;
use Behat\MinkExtension\Context\MinkContext;


/**
 * Class WaitContext
 */
class WaitContext extends MinkContext
{
    /**
     * @var array
     */
    protected $validConditions = [
        "document.readyState == 'complete'",           // Page is ready
        "typeof $ != 'undefined'",                     // jQuery is loaded
        "!$.active",                                   // No ajax request is active
        "$('#page').css('display') == 'block'",        // Page is displayed (no progress bar)
        "$('.loading-mask').css('display') == 'none'", // Page is not loading (no black mask loading page)
        "$('.jstree-loading').length == 0",            // Jstree has finished loading
    ];

    /**
     * @Given I wait milliseconds :arg1
     */
    public function iWaitMilliseconds($arg1)
    {
        $this
            ->getSession()
            ->wait($arg1);
        return;
    }
    /**
     * @Given /^I wait till "([^"]*)" or to see "([^"]*)"$/
     *
     * @param  string    $maxTime
     * @param  string    $text
     * @throws Exception
     */
    public function iWaitTillOrToSee(string $maxTime = "10000", string $text = "")
    {
        $maxTime = ((int)$maxTime < 500) ? 500 : (int)$maxTime;
        $time = 0;
        while ($time <= $maxTime) {
            try {
                $this->assertSession()->pageTextContains($this->fixStepArgument($text));
                return;
            } catch (\Throwable $e) {
                $time = $time + 500;
            }
            $this->getSession()->wait(500);
        }

        throw new \Exception(sprintf('Timeout of %d reached when checking on %s', $time, $text));
    }

    /**
     * @Given /^I wait till "([^"]*)" or for condition "([^"]*)"$/
     *
     * Note: if condition is empty then all the valid condition will be called, if condition is false than just wait.
     *
     * From:
     * @author    Gildas Quéméner <gildas@akeneo.com>
     * @copyright 2013 Akeneo SAS (http://www.akeneo.com)
     * @license   http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
     *
     * @param  string    $time
     * @param  string    $condition
     * @throws Exception
     */
    public function iWaitTillOrForCondition(string $time = "10000", string $condition = "")
    {
        if (!$this->getSession()->getDriver() instanceof Selenium2Driver) {
            throw new \Exception("Error: getDriver is not an instance of Selenium2Driver");
        }

        if (!empty($condition)) {
            if (!$this->validateCondition($condition)) {
                throw new \Exception("Error: Invalid conditions");
            }
        }

        $start = microtime(true);
        $end = $start + $time / 1000.0;

        $conditions = empty($condition) ? $this->validConditions : [ $condition ];
        $condition = empty($condition) ? implode(' && ', $this->validConditions) : $condition;



        // Make sure the AJAX calls are fired up before checking the condition
        $this->getSession()->wait(100, false);
        $this->getSession()->wait($time, $condition);


        // Check if we reached the timeout unless the condition is false to explicitly wait the specified time
        if ($condition == "false" && microtime(true) > $end) {
            throw new \Exception(sprintf('Timeout of %d reached when checking on %s', $time, $condition));
        }

        foreach ($conditions as $condition) {
            $result = $this->getSession()->evaluateScript($condition);
            if (!$result) {
                throw new \Exception(
                    sprintf(
                        'Timeout of %d reached when checking on "%s"',
                        $time,
                        $condition
                    )
                );
            }
        }
    }

    /**
     * @param  string $condition
     * @return bool
     */
    protected function validateCondition(string $condition) : bool
    {
        return in_array($condition, $this->validConditions) ? true : ($condition == 'false');
    }

}
