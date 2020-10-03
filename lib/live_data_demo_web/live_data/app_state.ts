export type State = 

export type Actions = {

}

export type ActionName = keyof Actions

export type Action = <T extends ActionName>(
  action: T,
  params: Actions[T]
) => Promise<null>
