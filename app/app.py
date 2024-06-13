from shiny import App, Inputs, Outputs, Session, render, ui

app_ui = ui.page_fluid(
    ui.output_text("text")
)


def server(input: Inputs, output: Outputs, session: Session):
    @render.text
    def text():
        return 'Hello, World!'


app = App(app_ui, server)