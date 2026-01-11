package com.devops;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests unitaires pour l'application
 */
public class AppTest {
    
    @Test
    public void testAppExists() {
        App app = new App();
        assertNotNull(app);
    }
    
    @Test
    public void testMainMethod() {
        // Test que la méthode main peut être exécutée sans erreur
        assertDoesNotThrow(() -> App.main(new String[]{}));
    }
}
