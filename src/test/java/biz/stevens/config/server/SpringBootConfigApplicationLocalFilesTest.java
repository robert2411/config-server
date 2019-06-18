package biz.stevens.config.server;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.cloud.config.environment.Environment;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

@ActiveProfiles("native")
@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class SpringBootConfigApplicationLocalFilesTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void contextLoads() throws Exception {
    }

    @Test
    public void shouldReturnExpectedConfig() throws Exception {
        Environment out = this.restTemplate.getForObject("/app/profile/",
                Environment.class);
        Assert.assertEquals("app", out.getName());
        Assert.assertEquals("profile", out.getProfiles()[0]);
        Assert.assertFalse(out.getPropertySources().isEmpty());
        Assert.assertEquals("world", out.getPropertySources().get(0).getSource().get("hello"));
    }
}