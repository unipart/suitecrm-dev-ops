<?php
/**
 * Created by PhpStorm.
 * User: Riccardo De Leo
 */

/**
 * Class LoginContext
 */
class LoginContext extends FeaturesContext
{
    /**
     * @var array
     */
    protected $loginData = [
        'user_name' => 'admin',
        'username_password' => 'admin1234'
    ];

    /**
     * @BeforeScenario
     */
    public function login()
    {
        $this->visitPath('/');

        $this->iWaitMilliseconds(1000);

        foreach ($this->loginData as $field => $value) {
            $field = $this->fixStepArgument($field);
            $value = $this->fixStepArgument($value);
            $this->getSession()->getPage()->fillField($field, $value);
        }

        $button = $this->fixStepArgument('Login');
        $this->getSession()->getPage()->pressButton($button);
    }

}
