/*
 * Copyright 2020 Foreseeti AB
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.mal_lang.page.test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class TestMain {
  private static PrintStream oldOut;
  private static PrintStream oldErr;
  private ByteArrayOutputStream out;
  private ByteArrayOutputStream err;

  private String getOut() {
    return out.toString(StandardCharsets.UTF_8);
  }

  private String getErr() {
    return err.toString(StandardCharsets.UTF_8);
  }

  @BeforeEach
  public void init() {
    oldOut = System.out;
    oldErr = System.err;
    out = new ByteArrayOutputStream();
    err = new ByteArrayOutputStream();
    System.setOut(new PrintStream(out));
    System.setErr(new PrintStream(err));
  }

  @AfterEach
  public void clear() {
    System.setOut(oldOut);
    System.setErr(oldErr);
  }

  @Test
  public void testMain() {
    Main.main();
    assertEquals("Page Test\n", getOut());
    assertTrue(getErr().isEmpty());
  }
}
